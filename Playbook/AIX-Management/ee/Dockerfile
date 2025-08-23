# AIX Management Execution Environment
# Built from creator-base for AAP 2.5 compatibility

FROM quay.io/ansible/creator-base:latest

# Set labels for container identification
LABEL name="ee-aix" \
      version="1.0" \
      description="Execution Environment for AIX Management" \
      maintainer="AIX Management Team"

# Set environment variables
ENV ANSIBLE_GATHERING=smart \
    ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_SSH_PIPELINING=true

# Install Python dependencies first, including ansible-core
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir ansible-core>=2.14.0 && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt

# Install Ansible collections
COPY requirements.yml /tmp/requirements.yml
RUN ansible-galaxy collection install -r /tmp/requirements.yml

# Create working directory
WORKDIR /runner

# Verify installation
RUN ansible --version && \
    ansible-galaxy collection list && \
    echo "AIX Management Execution Environment ready"