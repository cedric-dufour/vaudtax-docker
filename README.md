Containerized VaudTax installation for Linux
==

TL;DR:

* Vaud state doesn't care much about Linux

* `export VAUDTAX_YEAR='2021'`

* build the Docker Image: [./build](./build)

* run the Docker Image: [./run](./run)

Other available environment variables:

* `VAUDTAX_DATA`: path to your VaudTax data, mounted in ` /home/vaudtax/data`;
  e.g. `export VAUDTAX_DATA="${HOME}"`

Post scriptum: VaudTax uses long-deprecated libraries - like `libwebkitgtk-1.0` - which are no
longer available on recent Linux distributions. This containerized installation works around this
issue by using `ubuntu:bionic (18.04, LTS)` as base image.

Official website: [VaudTax 2021](https://www.vd.ch/themes/etat-droit-finances/impots/impots-pour-les-individus/remplir-ma-declaration-dimpot/vaudtax-2021/)
