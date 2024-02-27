# VM-EDU

VM-EDU is a Packer and Vagrant VM factory for two courses: Digital Forensics and Incident Response (DFIR) & Malware Analysis. This project automates the process of creating and configuring virtual machines for educational purposes.

## Directory Structure

```
.
├── README.md
├── packer
│   ├── configs
│   └── scripts
│   └── windows_10_22h2_base.json
└── vagrant
    ├── dfir
    ├── malware_analysis
    └── scripts
```

### Packer

- `windows_10_22h2_base.json`: Packer template for building the Windows 10 VM.
- `configs`: Contains the Autounattend.xml for unattended installations and a template for customizing the Vagrant environment.
- `scripts`: Scripts for configuring the Windows environment during the Packer build process.

### Vagrant

- `dfir` & `malware_analysis`: Directories containing Vagrantfiles for setting up environments specific to DFIR and malware analysis.
- `scripts`: Provisioning scripts used by Vagrant to install and configure tools in the VMs.

## Prerequisites

- [Packer](https://www.packer.io/downloads)
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or any other provider supported by Vagrant and Packer)

## Setup

1. Clone this repository to your local machine.
2. Navigate to the `packer` directory and build the base Windows 10 22H2 image with Packer:
   ```
   cd packer
   packer build windows_10_22h2_base.json
   ```
3. After the build is complete, navigate to the `vagrant` directory and add the generated box to Vagrant:
   ```
   cd ../vagrant
   vagrant box add --name windows_10_analyst ../packer/windows_10_analyst_virtualbox.box
   ```
4. Navigate to either the `dfir` or `malware_analysis` directory and start the Vagrant environment:
   ```
   cd dfir
   vagrant up
   ```

## Usage

After setting up the Vagrant environment, you can access the VMs via VirtualBox or any other VM provider you've used. The environments come pre-configured with tools and settings suitable for DFIR or malware analysis.

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests with your improvements.

## License

[MIT License](LICENSE)

## Acknowledgments

- Thanks to all the open-source tools and their maintainers that made this project possible.
- Much thanks to [Flare-VM](https://github.com/mandiant/flare-vm) for the setup of the malware analysis VM.
- Special thanks to [Chocolatey](https://chocolatey.org/) for simplifying software installations on Windows.