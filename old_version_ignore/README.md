Can you make the modifications required to this repository to achieve the following:

**Task 1:**

deploy Rancher to an AWS Lightsail instance, with working SSL.

install method: Single Node Using Docker




the following apps (mapped to the URL suffixes provided below) to Rancher:

APP: Directus (<https://docs.directus.io/self-hosted/docker-guide.html>)
URL: your.domain.com/directus

APP: Matamo (<https://github.com/matomo-org/docker/>)
URL: your.domain.com/matamo

kindly document your changes, and the steps you took, in this README.md file.

All setup instructions are provided below:

Many Thanks!


**Task pre-requisites**
To complete this task you will need:
 - A free AWS account
 - A spare domain that you own which you can use temporarily while you work on this job
 - VScode, setup for remote development (guide here <https://code.visualstudio.com/docs/remote/ssh#_getting-started>)


**Follow Task setup steps in this doc**


<https://docs.google.com/document/d/1RVttdiJbjKUF5VxSbwBlsIRe1ZIR2FhNpTavMlZqyj8/edit?usp=sharing>

Once done, return here and...

in vscode, log into the server, open a terminal, Then paste and run the following:

```
git clone <https://github.com/dannyblaker/rancher_test.git>
cd rancher_test
find . -name "*.sh" -execdir chmod u+x {} +
./setup.sh
./setup_cert.sh
```

note: 

- i haven't been able to get the SSL working
