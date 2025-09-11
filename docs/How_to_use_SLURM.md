# Caloba Slurm Cluster Usage Tutorial 💻

This document serves as a comprehensive guide to utilizing the essential commands of the Slurm Workload Manager on the Caloba cluster. The commands covered include **`salloc`**, **`squeue`**, **`scancel`**, and **`sbatch`**.

-----

## 1\. Interactive Resource Allocation with `salloc` 🧠

The `salloc` command is used to allocate resources for a job and provide an interactive shell on the assigned compute node. This functionality is particularly useful for debugging, compiling software, and conducting interactive tests.

### Syntax

The general syntax is as follows:

```bash
salloc [options]
```

### Partitions (Queues) 📋

The Caloba cluster is configured with the following partitions:

| Partition  | Description                                                              |
|------------|--------------------------------------------------------------------------|
| `cpu-large`| Designated for CPU-intensive jobs with substantial memory requirements.  |
| `gpu`      | Allocated for jobs requiring a single GPU.                               |
| `gpu-large`| Dedicated to jobs that necessitate multiple GPUs.                        |

### Usage Examples 💡

**1. CPU Node Allocation:**
To allocate a single node from the `cpu-large` partition with 8 CPU cores, execute:

```bash
salloc --partition=cpu-large
```

**2. GPU Node Allocation:**
To request a single GPU from the `gpu` partition, use the `--gres` option:

```bash
salloc --partition=gpu
```

Upon allocation, one may verify GPU access by running **`nvidia-smi`**.



-----

## 2\. Job Status Monitoring with `squeue` 🚦

The `squeue` command allows users to monitor the status of jobs in the queue.

### Usage

To display a list of all jobs submitted by the current user, use the `--me` flag:

```bash
squeue --me
```

The output will provide information such as job ID, partition, job name, user, status (e.g., `R` for Running, `PD` for Pending), and resource utilization.

### Common Options

  * `squeue -u <username>`: Displays jobs for a specified user.
  * `squeue -t PD`: Filters the output to show only pending jobs.
  * `squeue -t R`: Filters the output to show only running jobs.
  * `squeue -j <job_id>`: Provides detailed information for a specific job ID.

-----

## 3\. Job Termination with `scancel` ❌

The `scancel` command is used to terminate a job that is either running or pending.

### Usage

To cancel a single job, the job ID must be provided:

```bash
scancel <job_id>
```

### Advanced Options

  * `scancel --user=<username>`: Cancels all jobs submitted by the specified user.
  * `scancel -u <username> --state=PD`: Cancels all pending jobs for the specified user.

-----

## 4\. Batch Job Submission with `sbatch` 📝

For non-interactive, long-running tasks, `sbatch` is used to submit a job script to the queue. The job will commence execution when the requested resources become available.

### Job Script Structure

A batch script is a shell script that begins with **`#SBATCH`** directives, which specify the job's resource requirements.

### Example: Machine Learning Training with Output JSON 🤖

A common practice in machine learning is to output the final model metrics and parameters to a file for later analysis. This example demonstrates a job that accepts parameters and outputs a JSON file with a user-defined name.

First, let's update our Python script, `train_model.py`, to accept an output file name and write results to it.

```python
import argparse
import os
import torch
import json

def train_model(epochs, learning_rate, batch_size, output_file):
    """
    A placeholder function for a machine learning training process.
    """
    print(f"Starting training with the following parameters:")
    print(f"Epochs: {epochs}")
    print(f"Learning Rate: {learning_rate}")
    print(f"Batch Size: {batch_size}")
    
    # Check for GPU availability
    if torch.cuda.is_available():
        print("GPU is available. Using it for training.")
        device = torch.device("cuda")
    else:
        print("GPU not available. Falling back to CPU.")
        device = torch.device("cpu")
        
    print(f"Training on device: {device}")
    
    # Placeholder for your actual training code
    # ...
    
    # Simulate a result
    final_metrics = {
        "epochs": epochs,
        "learning_rate": learning_rate,
        "batch_size": batch_size,
        "final_accuracy": 0.95 + (epochs * 0.001)  # Simulated result
    }
    
    # Write the results to the specified output file
    with open(output_file, 'w') as f:
        json.dump(final_metrics, f, indent=4)
    
    print(f"Training complete! Metrics saved to {output_file}. 🎉")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Machine Learning Training Script")
    parser.add_argument("--epochs", type=int, default=10, help="Number of training epochs")
    parser.add_argument("--learning-rate", type=float, default=0.001, help="Optimizer learning rate")
    parser.add_argument("--batch-size", type=int, default=32, help="Batch size for training")
    parser.add_argument("--output-file", type=str, required=True, help="Path to the output JSON file")
    
    args = parser.parse_args()
    
    train_model(args.epochs, args.learning_rate, args.batch_size, args.output_file)

```

Now, here is the `sbatch` script to run this job, passing the parameters and a dynamically named output file.

```bash
#!/bin/bash
#SBATCH --job-name=ML_Training
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=slurm-ml-%j.out

# Load the required environment (e.g., a virtualenv environment with PyTorch/TensorFlow)
source my_ml_env/activate  # Replace with the name of your virtualenv environment

# Define parameters for the training script
EPOCHS=20
LEARNING_RATE=0.0005
BATCH_SIZE=64

# Define the output file name, including the Slurm Job ID for uniqueness
OUTPUT_FILE="results/training_run_${SLURM_JOB_ID}.json"

# Create the output directory if it doesn't exist
mkdir -p results

# Run the Python script with the specified parameters and output file
python train_model.py \
    --epochs ${EPOCHS} \
    --learning-rate ${LEARNING_RATE} \
    --batch-size ${BATCH_SIZE} \
    --output-file ${OUTPUT_FILE}
```

### Example: Iterating over JSON Files with Output JSON ⚙️

For running multiple experiments, it is useful to loop over configuration files and generate a unique output file for each.

First, let's assume you have a directory `configs/` with JSON files. Your Python script `train_model.py` should be updated to accept the config file path and the output file name.


Let's assume you have a directory named `configs/` with JSON files like this:

`configs/exp_01.json`

```json
{
  "epochs": 100,
  "learning_rate": 0.001,
  "batch_size": 32,
  "model_name": "resnet18"
}
```

`configs/exp_02.json`

```json
{
  "epochs": 50,
  "learning_rate": 0.0001,
  "batch_size": 64,
  "model_name": "resnet50"
}
```

Your Python training script (`train_model.py`) should be modified to accept a single argument: the path to the JSON file.

```python
import argparse
import json
import os
#... other imports

def train_model(config_file, output_file):
    with open(config_file, 'r') as f:
        config = json.load(f)
    
    print("Training with the following configuration:")
    print(json.dumps(config, indent=2))
    
    # ... your training logic using 'config' dictionary ...

    # Simulate final metrics based on the config
    final_metrics = config
    final_metrics["final_accuracy"] = 0.95 + (config['epochs'] * 0.001)
    
    # Write the results to the specified output file
    with open(output_file, 'w') as f:
        json.dump(final_metrics, f, indent=4)
        
    print(f"Training finished! Results saved to {output_file}. 🎉")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("config_file", help="Path to the JSON configuration file")
    parser.add_argument("output_file", help="Path to the output JSON file")
    args = parser.parse_args()
    
    train_model(args.config_file, args.output_file)
```

Now, create the `sbatch` script to loop through the configuration files and submit a job for each one. This script will dynamically generate unique output file names.

```bash
#!/bin/bash
# A simple loop to submit multiple jobs

CONFIGS_DIR="./configs"
RESULTS_DIR="./results"

# Create the results directory if it doesn't exist
mkdir -p ${RESULTS_DIR}

# Loop through all .json files in the configs directory
for config_file in ${CONFIGS_DIR}/*.json; do
    
    # Extract the base name of the config file to use for the output file and job name
    CONFIG_NAME=$(basename ${config_file} .json)
    
    # Define a unique output file name
    OUTPUT_FILE="${RESULTS_DIR}/${CONFIG_NAME}_metrics.json"

    echo "Submitting job for config: ${CONFIG_NAME}, output file: ${OUTPUT_FILE}"
    
    # Use sbatch to submit a new job for each file
    # The --wrap option is a convenient way to run a single command without a separate script file
    sbatch --job-name="ML_${CONFIG_NAME}" \
           --partition=gpu \
           --nodes=1 \
           --cpus-per-task=4 \
           --mem=16G \
           --time=04:00:00 \
           --output="slurm-${CONFIG_NAME}-%j.out" \
           --wrap="singularity exec --nv /path/to/my/ml_container.sif python /opt/my_ml_project/train_model.py ${config_file} ${OUTPUT_FILE}"
done

echo "All jobs submitted. Check squeue to monitor their status."
```

### Submission

To submit all the jobs defined by your JSON files, you only need to run the `sbatch` script itself:

```bash
sbatch submit_all_jobs.sh
```

A job ID will be returned for each submitted job. You can then use `squeue` to monitor all of your training runs. Happy computing\! 🥳