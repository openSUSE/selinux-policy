# openSUSE SELinux policy

This repository contains the openSUSE SELinux policy.

The openSUSE SELinux policy is a downstream of the [Fedora SELinux policy](https://github.com/fedora-selinux/selinux-policy) with additional openSUSE specific changes.

## How this is developed

- Monthly policy update: Every month the openSUSE SELinux group fetches the new updates in the Fedora `rawhide` branch into the openSUSE `factory` branch of this repository. Those changes will be submitted then to openSUSE Tumbleweed.
  Please check the changelog in OBS for details of those updates.
- Additionally, openSUSE only policies and fixes are added to this repository during the month and submitted by the team.

Branches:
- `factory`: Development branch for all openSUSE rolling release distros (openSUSE Tumbleweed, openSUSE MicroOS, Aeon, SLFO:Main,...)
- `slfo-1.2`: Maintenance branch SLE 16.0 and SL Micro 6.2
- `slfo-1.1`: Maintenance branch SL Micro 6.1
- `alp-1.0`: Maintenance branch SL Micro 6.0
- `sle-micro-5.x`: Maintenance branch for respective SLE Micro 5.x

For selinux-policy package build related docs: https://src.opensuse.org/pool/selinux-policy

## Development

Add devel project:
```
zypper addrepo https://download.opensuse.org/repositories/security:SELinux/openSUSE_Tumbleweed/security:SELinux.repo
zypper refresh
```

Install dependencies:
```
zypper si selinux-policy selinux-policy-targeted
```

Then follow the [INSTALL](INSTALL) documentation.

## Documentation

A comprehensive documentation regarding the processes and differences to the fedora policy can be found in the openSUSE Wiki:
https://en.opensuse.org/Portal:SELinux


## Reporting Bugs

Please report bugs in the openSUSE Bugzilla. A guide on gathering all required information can be found here:
https://en.opensuse.org/openSUSE:Bugreport_SELinux

## Contributing

Please contribute general fixes to the [Fedora SELinux policy](https://github.com/fedora-selinux/selinux-policy).

If you have a openSUSE specific fixes you can either:
- open a PR on GitHub: https://github.com/openSUSE/selinux-policy/pulls
- or: send patches via email to: https://lists.opensuse.org/archives/list/selinux@lists.opensuse.org/
