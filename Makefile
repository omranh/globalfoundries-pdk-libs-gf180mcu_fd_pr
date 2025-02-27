# Copyright 2022 GlobalFoundries PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The top directory where environment will be created.
TOP_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# A pip `requirements.txt` file.
# https://pip.pypa.io/en/stable/reference/pip_install/#requirements-file-format
REQUIREMENTS_FILE := requirements.txt

# https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
ENVIRONMENT_FILE := pdk_regression.yml

include third_party/make-env/conda.mk

# Lint python code
lint: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) flake8 .

################################################################################
##  CLONING PV REPO
################################################################################

DRC-PV: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) rm -rf globalfoundries-pdk-libs-gf180mcu_fd_pv/ && git clone https://github.com/efabless/globalfoundries-pdk-libs-gf180mcu_fd_pv.git

################################################################################
## DRC Regression section
################################################################################
# DRC main testing
test-DRC-main: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) klayout -v

# DRC main testing
test-DRC-switch: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) klayout -v

################################################################################
## LVS Regression section
################################################################################
# LVS main testing
test-LVS-main: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) klayout -v

# LVS main testing
test-LVS-switch: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) klayout -v

################################################################################
## ngspice Regression section
################################################################################
# ngspice models regression
test-ngspice-%: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd models/ngspice/testing/regression/$*/ && python3 models_regression.py

################################################################################
## PCells Regression section
################################################################################
# fet main testing
test-nfet_03v3-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-nfet_03v3

test-nfet_05v0-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-nfet_05v0

test-nfet_06v0-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-nfet_06v0

test-pfet_03v3-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-pfet_03v3

test-pfet_05v0-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-pfet_05v0

test-pfet_06v0-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-pfet_06v0

# diode main testing
test-diode-pcells:| DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-diode

# moscap main testing
test-moscap-pcells: |DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-cap_mos

# mimcap main testing
test-mimcap-pcells: |DRC-PV DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ &&  make test-MIM

# res main testing
test-res-pcells: | DRC-PV $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) cd cells/klayout/pymacros/testing/ && make test-RES 

