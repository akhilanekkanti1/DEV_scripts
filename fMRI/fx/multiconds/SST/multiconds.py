import argparse
import json
import re
from os import PathLike
from pathlib import Path
from typing import Union, List

import numpy
import scipy.io

# Define some constants interpret the behavioral data
NO_RESPONSE = 0
# Key codes that correspond to random key presses
RANDOM_3_KEY = 32
RANDOM_F_KEY = 9
RANDOM_U_KEY = 24
RANDOM_UNINTERPRETABLE_KEY = 9999
#

BUTTON_BOX_2 = 90
BUTTON_BOX_3 = 91
BUTTON_BOX_4 = 92
BUTTON_BOX_5 = 93
BUTTON_BOX_6 = 94
BUTTON_BOX_7 = 95
R_KEY = 21
L_KEY = 15
LESS_THAN_KEY = 197
GREATER_THAN_KEY = 198

GO_TRIAL = 0
NO_GO_TRIAL = 1
NULL_TRIAL = 2

COUNT_NO_GO = 32
COUNT_GO = 96
COUNT_NULL = 128
COUNT_RESPONSE = 256

STUDY_ID = 'DEV'


def read_data(file: Path):
    """
    Read behavioral data out of the .mat files. The data is interpreted as follows:

    column 0 - trial number
    column 2 - trial type. 0=Go, 1=NoGo, 2=null trial (there are 96 Go, 32 NoGo, 128 null)
    column 6 - subject response (keycode). 0=no response.
    The participant is supposed to respond with left or right hand depending on the stimulus presented.
    Keycodes 91=left, 94=right correspond to (3, 6) buttons on button box in MRI,
    but there are some other keypress pairs that are common:
    (21, 15) correspond to ('r', 'l') keys on keyboard
    (197, 198) correspond to ('<', '>') keys on keyboard
    (92, 93) correspond to (4, 5) buttons on button box in MRI
    (90, 94) correspond to (2, 6) buttons on button box in MRI
    (94, 95) correspond to (6, 7) buttons on button box in MRI (which are on the same hand)
    column 8 - reaction time. For Go trials, this is the duration.
    column 14 - trial duration (seconds).
    column 15 - start time of trial (seconds)
    """
    mat_dict = scipy.io.loadmat(str(file), appendmat=False)
    response_data = mat_dict['Seeker']
    trial_number = response_data[:, 0]
    go_no_go_condition = response_data[:, 2]

    subject_response = response_data[:, 6]
    reaction_time = response_data[:, 8]

    trial_duration = response_data[:, 14]
    trial_start_time = response_data[:, 15]

    go_success = numpy.logical_and(go_no_go_condition == GO_TRIAL,
                                   numpy.logical_or(subject_response == BUTTON_BOX_3, subject_response == BUTTON_BOX_6))
    # For successful go trials, the trial only lasts until the participant reacts,
    # so replace the trial duration with the participant reaction time.
    numpy.copyto(trial_duration, reaction_time, where=go_success)

    return trial_number, go_no_go_condition, subject_response, reaction_time, trial_duration, trial_start_time


def create_masks(condition: numpy.ndarray, response: numpy.ndarray) -> List:
    """Create masks of conditions"""
    temp = numpy.logical_or.reduce((response == NO_RESPONSE, response == RANDOM_3_KEY,
                                    response == RANDOM_F_KEY, response == RANDOM_U_KEY,
                                    response == RANDOM_UNINTERPRETABLE_KEY))
    go_fail = numpy.logical_and(condition == GO_TRIAL, temp)
    temp = numpy.logical_or.reduce((response == BUTTON_BOX_3, response == BUTTON_BOX_6,
                                    response == BUTTON_BOX_4, response == BUTTON_BOX_5,
                                    response == R_KEY, response == L_KEY,
                                    response == LESS_THAN_KEY, response == GREATER_THAN_KEY,
                                    response == BUTTON_BOX_2, response == BUTTON_BOX_7))
    go_success = numpy.logical_and(condition == GO_TRIAL, temp)

    no_go_fail = numpy.logical_and(condition == NO_GO_TRIAL, response != NO_RESPONSE)
    no_go_success = numpy.logical_and(condition == NO_GO_TRIAL, response == NO_RESPONSE)

    null_trials = (condition == NULL_TRIAL)

    return list((go_success, no_go_success, no_go_fail, null_trials, go_fail))


def create_trials(trial_number: numpy.ndarray, trial_start_time: numpy.ndarray, trial_duration: numpy.ndarray):
    # Output names (trial number or condition name (GoFail, GoSuccess, NoGoFail, NoGoSuccess)),
    # onsets (when the thing started),
    # durations (how long the thing lasted)
    names = numpy.asarray(trial_number, dtype=numpy.object)
    onsets = numpy.asarray(trial_start_time, dtype=numpy.object)
    durations = numpy.asarray(trial_duration, dtype=numpy.object)

    trials = {'names': names,
              'onsets': onsets,
              'durations': durations}
    return trials


def create_conditions(start_time: numpy.ndarray, duration: numpy.ndarray, masks: List):
    names = numpy.asarray(['CorrectGo', 'CorrectStop', 'FailedStop', 'Cue', 'FailedGo'], dtype=numpy.object)
    onsets = numpy.zeros((len(masks),), dtype=numpy.object)
    durations = numpy.zeros((len(masks),), dtype=numpy.object)
    # onsets and durations have to be reshaped from 1-d numpy arrays to Nx1 arrays so when written
    # by scipy.io.savemat, the correct cell array is created in matlab
    for i, mask in enumerate(masks):
        onsets[i] = start_time[mask].reshape(numpy.count_nonzero(mask), 1)
        durations[i] = duration[mask].reshape(numpy.count_nonzero(mask), 1)

    conditions = {'names': names,
                  'onsets': onsets,
                  'durations': durations}
    return conditions


def write_betaseries(input_dir: Union[PathLike, str], subject_id: str, wave: str, trials):
    path = Path(input_dir) / 'betaseries'
    path.mkdir(parents=True, exist_ok=True)
    file_name = f'DEV{subject_id}_{wave}_SST1.mat'

    scipy.io.savemat(str(path / file_name), trials)


def write_conditions(input_dir: Union[PathLike, str], subject_id: str, wave: str, trials):
    path = Path(input_dir) / 'conditions'
    path.mkdir(parents=True, exist_ok=True)
    file_name = f'DEV{subject_id}_{wave}_SST1.mat'

    scipy.io.savemat(str(path / file_name), trials)


def write_bids_events(input_dir: Union[PathLike, str], subject_id: str, wave: str, trials):
    # Write the events.tsv to BIDS only if the BIDS structure already exists
    subject_path = Path(input_dir) / f'sub-{STUDY_ID}{subject_id}'
    if subject_path.exists():
        path = Path(input_dir) / f'sub-{STUDY_ID}{subject_id}' / f'ses-wave{wave}'
        if wave == '1' or wave == '2':
            path = path / 'func'
        else:
            path = path / 'beh'

        path.mkdir(parents=True, exist_ok=True)
        file_name = Path(f'sub-{STUDY_ID}{subject_id}_ses-wave{wave}_task-SST_acq-1_events.tsv')

        numpy.savetxt(str(path / file_name),
                      trials,
                      delimiter='\t',
                      header='onset\tduration\ttrial_type',
                      comments='',
                      fmt=['%10.5f', '%10.5f', '%s'])

        file_name = Path(f'sub-{STUDY_ID}{subject_id}_ses-wave{wave}_task-SST_acq-1_events.json')
        write_events_description(path, file_name)


def write_events_description(path: Path,
                             file_name: Path):
    desc = {
        "onset": {
            "LongName": "Onset",
            "Description": "Onset of the event measured from the beginning of the acquisition of "
                           "the first volume in the corresponding task imaging data file.",
            "Units": "s"
        },
        "duration": {
            "LongName": "Duration",
            "Description": "Duration of the event, measured from onset.",
            "Units": "s"
        },
        "trial_type": {
            "LongName": "Categorization of a response inhibition task",
            "Description": "Education level, self-rated by participant",
            "Levels": {
                "correct-go": "Go trial, correct response",
                "failed-go": "Go trial, incorrect or no response",
                "correct-stop": "No-go or stop trial, correct response",
                "failed-stop": "No-go or stop trial, incorrect response",
                "null": "Null trial where cue stimulus is presented for duration"
            }
        }
    }
    with open(str(path / file_name), 'w') as f:
        json.dump(desc, f, indent=4)


def main(input_dir: str, bids_dir: str = None):
    files = list(Path(input_dir).glob('DEV*.mat'))
    files.sort()
    pattern = 'DEV(\\d{3})_run(\\d{1})_.*mat'
    for f in files:
        match = re.search(pattern, str(f.name))
        if match:
            subject_id, wave_number = match.groups()

            # Read data out of the .mat file
            trial_number, go_no_go_condition, subject_response, reaction_time, trial_duration, trial_start_time = \
                read_data(f)

            # Create masks for the various conditions
            masks = create_masks(go_no_go_condition, subject_response)

            # Perform some quality checking on the numbers of responses (should be 256),
            # the number of null trials (should be 128),
            # go trials (should be 96), and no-go trials (should be 32)
            if subject_response.size != COUNT_RESPONSE:
                print(f'Wrong number of responses   : (subject, expected, actual) '
                      f'({subject_id}, {COUNT_RESPONSE}, {subject_response.size})')
            if numpy.count_nonzero(masks[0] + masks[-1]) != COUNT_GO:
                print(f'Wrong number of go trials : (subject, run, expected, actual) '
                      f'({subject_id}, {wave_number}, {COUNT_GO}, {numpy.count_nonzero(masks[0] + masks[-1])})')
            if numpy.count_nonzero(masks[1] + masks[2]) != COUNT_NO_GO:
                print(f'Wrong number of no-go trials: (subject, expected, actual) '
                      f'({subject_id}, {COUNT_NO_GO}, {numpy.count_nonzero(masks[1] + masks[2])})')
            if numpy.count_nonzero(masks[3]) != COUNT_NULL:
                print(f'Wrong number of null trials : (subject, expected, actual) '
                      f'({subject_id}, {COUNT_NULL}, {numpy.count_nonzero(masks[3])})')

            if bids_dir:
                trial_type = numpy.empty_like(trial_number, dtype=numpy.object)
                trial_type_names = ['correct-go', 'correct-stop', 'failed-stop', 'null', 'failed-go']
                for mask, name in zip(masks, trial_type_names):
                    numpy.putmask(trial_type, mask, name)
                write_bids_events(bids_dir, subject_id, wave_number,
                                  numpy.stack((trial_start_time, trial_duration, trial_type), axis=1))
            else:
                trials = create_trials(trial_number, trial_start_time, trial_duration)

                # Create paths and file names
                write_betaseries(input_dir, subject_id, wave_number, trials)

                conditions = create_conditions(trial_start_time, trial_duration, masks)
                write_conditions(input_dir, subject_id, wave_number, conditions)


if __name__ == "__main__":
    description = 'Create multi-condition files for SST task in DEV study'

    parser = argparse.ArgumentParser(description=description,
                                     add_help=True,
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('-i', '--input', metavar='Input directory', action='store',
                        type=str, required=True,
                        help='absolute path to directory containing behavioral output from the SST task.',
                        dest='input_dir'
                        )
    parser.add_argument('-b', '--bids', metavar='BIDS directory', action='store',
                        type=str, required=False, default=None,
                        help='absolute path to your top level bids folder.',
                        dest='bids_dir'
                        )
    args = parser.parse_args()

    main(args.input_dir, args.bids_dir)
