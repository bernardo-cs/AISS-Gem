![Alt text](http://www.ist.utl.pt/img/tecnico.png)

# Aiss Gem: Sending Cyphered, Zipped and Signed Emails

> Aiss is a gem that lets you send emails 128 AES cyphered,
> zipped and PKCS11 signed emails.
>
> The signature and cyphered/zipped message are sent on the email
> header, a default email message is sent in body for all recipients that 
> are not using this gem


## Installation

Install it yourself as:

    $ gem install aiss

## Usage

* See the rspec tests under spec/aiss for general usage.
* There is a default gmail username/pw setup inside the gem for simplicity sake
* Do not use your own email since it will errase all your emails!!
* You need a portuguese citizen card and password in order to send signed emails

## About
> AES cyphering is done through Fast-AES. PKCS11 signature and verification is
> done through two java projects under files/jar and they're sources where
> placed in files/Java_sources

### Gem Architecture:

![Alt text](http://cl.ly/image/0X3S23181L3J/gem_arch.png)
