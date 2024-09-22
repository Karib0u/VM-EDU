# VM-EDU

VM-EDU is a Packer and Vagrant VM factory for two courses: Digital Forensics and Incident Response (DFIR) & Malware Analysis. This project automates the process of creating and configuring virtual machines for educational purposes, supporting either VMware or VirtualBox.

## Directory Structure

```
VM-EDU/
├── README.md
├── LICENSE
├── .gitignore
├── shared/
│   └── Vagrantfile.base
├── packer/
│   ├── packer.exe
│   ├── windows_10_22h2_base.json
│   ├── configs/
│   │   └── Autounattend.xml
│   └── scripts/
│       └── ... (various scripts)
├── vagrant/
│   ├── dfir/
│   │   └── Vagrantfile
│   └── malware_analysis/
│       └── Vagrantfile
└── scripts/
    └── ... (various scripts)
```

### Shared

- `Vagrantfile.base`: Contains common Vagrant configurations shared between Packer, DFIR, and malware analysis environments.

### Packer

- `windows_10_22h2_base.json`: Packer template for building the Windows 10 VM.
- `configs/`: Contains the Autounattend.xml for unattended installations.
- `scripts/`: Scripts for configuring the Windows environment during the Packer build process.

### Vagrant

- `dfir/` & `malware_analysis/`: Directories containing specialized Vagrantfiles for setting up environments specific to DFIR and malware analysis.

### Scripts

- Various scripts used by Vagrant to install and configure tools in the VMs.

## Setup

1. Clone this repository to your local machine.

2. Choose your virtualization platform: VMware or VirtualBox. You'll use this choice throughout the setup process.

3. Install Packer plugins:
   Navigate to the `packer` directory and run:
   ```bash
   cd packer
   packer plugins install github.com/hashicorp/vagrant
   ```
   Then, based on your chosen platform:
   
   For VirtualBox:
   ```bash
   packer plugins install github.com/hashicorp/virtualbox
   ```
   For VMware:
   ```bash
   packer plugins install github.com/hashicorp/vmware
   ```

4. Build the base Windows 10 22H2 image with Packer:
   
   For VirtualBox:
   ```bash
   packer build -only=virtualbox-iso windows_10_22h2_base.json
   ```
   For VMware:
   ```bash
   packer build -only=vmware-iso windows_10_22h2_base.json
   ```

5. Add the generated box to Vagrant:
   
   For VirtualBox:
   ```bash
   vagrant box add --name windows_10_analyst_virtualbox windows_10_analyst_virtualbox.box
   ```
   For VMware:
   Install the binary https://developer.hashicorp.com/vagrant/install/vmware
   ```bash
   vagrant plugin install vagrant-vmware-desktop
   vagrant box add --name windows_10_analyst_vmware windows_10_analyst_vmware.box
   ```

6. Start a DFIR environment:
   
   For VirtualBox:
   ```bash
   cd ../vagrant/dfir
   vagrant up --provider=virtualbox
   ```
   For VMware:
   ```bash
   cd ../vagrant/dfir
   vagrant up --provider=vmware_desktop
   ```

   Or for a malware analysis environment:
   
   For VirtualBox:
   ```bash
   cd ../vagrant/malware_analysis
   vagrant up --provider=virtualbox
   ```
   For VMware:
   ```bash
   cd ../vagrant/malware_analysis
   vagrant up --provider=vmware_desktop
   ```

## Usage

After setup, access the VMs via your chosen virtualization platform (VirtualBox or VMware). The environments are pre-configured with tools for DFIR or malware analysis.


## Contributing

Contributions are welcome! Please fork the repository and submit pull requests with your improvements.

## License

[MIT License](LICENSE)

## Acknowledgments

- Thanks to all the open-source tools and their maintainers that made this project possible.
- Much thanks to [Flare-VM](https://github.com/mandiant/flare-vm) for the setup of the malware analysis VM.
- Special thanks to [Chocolatey](https://chocolatey.org/) for simplifying software installations on Windows.