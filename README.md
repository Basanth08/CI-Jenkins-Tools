# CI-Jenkins-Tools

A collection of tools and utilities for Continuous Integration and Jenkins automation.

## Overview

This repository contains various tools, scripts, and configurations for CI/CD pipelines and Jenkins automation.


### Prerequisites

- Jenkins
- Docker (if applicable)
- Required dependencies (to be specified)

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd CI-Jenkins-Tools
```

2. Follow the specific setup instructions for each tool/component.

## Project Structure & My Approach

Here's how I organized and automated this project:

- **Diagrams/**: I created and stored architecture diagrams here, such as the CI/CD pipeline overview.
- **Resources/**: I collected and documented all the scripts, configuration snippets, and integration steps for Slack, Nexus, SonarQube, GitHub, and build jobs in this directory.
- **ansible/**: I wrote Ansible playbooks to automate infrastructure and application setup, making deployments repeatable and reliable.
- **src/**: I structured the source code with clear separation between main application logic and tests.
- **userdata/**: I developed shell scripts and configuration files to automate the setup of Jenkins, Nexus, and SonarQube on EC2 instances.

## Current Scenario

- Agile SDLC is followed.
- Developers make regular code changes.
- These commits need to be built and tested.
- Usually, the Build & Release Team handles this job.
- Alternatively, it may be the developers' responsibility to merge and integrate code.

## Problem: Issues with Current Situation

- In an Agile SDLC, there are frequent code changes.
- Code is not always tested frequently enough.
- This leads to the accumulation of bugs and errors in the codebase.
- Developers need to spend time reworking to fix these bugs and errors.
- The build and release process is often manual.
- There are inter-team dependencies that can slow down progress.

## Solution: Continuous Integration

- Build and test for every commit.
- Automated process for building and testing.
- Notifications for every build status.
- Fix code instantly if bugs or errors are found, rather than waiting.

## Process: Continuous Integration

Continuous Integration (CI) is a development practice where developers integrate code into a shared repository frequently, and each integration is verified by an automated build and test process. This helps to detect problems early, improve software quality, and reduce the time it takes to deliver updates.

## Benefits of CI Pipeline

- Fault isolation: Issues are detected and isolated quickly.
- Short MTTR (Mean Time To Repair): Faster recovery from failures.
- Agile: Supports agile development practices.
- No human intervention: Automated processes reduce manual effort.

## Tools Used

- **Jenkins**: Continuous Integration server
- **Git**: Version control system
- **Maven**: Build tool
- **Checkstyle**: Code analysis tool
- **Slack**: Notification system
- **Nexus**: Artifact/software repository
- **SonarQube**: Code analysis server
- **AWS EC2**: Compute resource

## Objectives and Goals

- Fault isolation
- Short MTTR (Mean Time To Repair)
- Fast turnaround on feature changes
- Less disruptive to development and deployment

## Architecture

The following diagram illustrates the CI/CD pipeline architecture used in this project:

![CI/CD Architecture](./Diagrams/architecture.png)

This architecture covers the flow from code commit to build, test, code analysis, artifact packaging, repository upload, and notifications.

## Flow of Execution (My Steps)

The following orchestrated steps show how I built a robust, automated, and scalable CI/CD pipeline:

1. **I authenticated with AWS**  
   I securely logged in to my AWS account to provision cloud resources.

2. **I generated secure access credentials**  
   I created a login key for safe and automated access to EC2 instances.

3. **I provisioned Security Groups**  
   I defined and configured Security Groups (SG) to control network access for:
   - Jenkins (CI Server)
   - Nexus (Artifact Repository)
   - SonarQube (Code Quality Server)

4. **I launched EC2 instances with automated user data scripts**  
   I spun up dedicated EC2 instances for Jenkins, SonarQube, and Nexus, each automatically configured using my user data scripts for seamless setup.

5. **I completed Jenkins post-installation configuration**  
   I finalized Jenkins setup, installed essential plugins, and prepared it for pipeline orchestration.

6. **I initialized the Nexus repository**  
   I set up Nexus and created three repositories to manage build artifacts efficiently.

7. **I completed SonarQube post-installation**  
   I configured SonarQube for advanced code quality analysis.

8. **I set up Jenkins pipeline jobs**  
   - I created and configured the main Build Job
   - I integrated Slack for real-time build notifications
   - I added Checkstyle for automated code analysis
   - I integrated SonarQube for continuous code quality checks
   - I configured artifact upload jobs for seamless delivery to Nexus

9. **I orchestrated the pipeline**  
   I connected all jobs into a unified Build Pipeline, ensuring smooth, end-to-end automation from code commit to artifact storage.

10. **I enabled automated build triggers**  
    I set up webhooks or polling to trigger builds automatically on code changes, ensuring rapid feedback and continuous integration.

11. **I performed end-to-end testing**  
    I validated the entire pipeline by pushing code changes from IntelliJ and monitoring the automated flow through build, test, analysis, and deployment.

12. **I implemented automated cleanup**  
    I created cleanup routines to remove temporary resources and maintain a cost-effective, clutter-free environment.

This approach delivers a modern, cloud-native CI/CD solution that maximizes automation, security, and developer productivity.

---
*This README is a work in progress. More information will be added as the project develops.* 

