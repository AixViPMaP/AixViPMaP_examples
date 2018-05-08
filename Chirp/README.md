Chirp
=====

Chirp is a lightweight I/O protocol and filesystem for grid computing.

HTCondor has an internal implementation of the Chirp protocol, which allows batch jobs to access their home storage while executing on a remote machine. If a HTCondor job is submitted with ```+WantIOProxy=True``` in its submit file, then HTCondor provides a proxy at the execution site that accepts the Chirp protocol and provides access to the submitter's storage. Users can invoke the ```condor_chirp``` command at runtime to load and store files, as well as update the job's classad.

Example
-------

### File Transfer from Execute Node to Submit Node

```bash
$(condor_config_val LIBEXEC)/condor_chirp put ExecuteNodeFile.txt SubmitNodeFile.txt
```

Links
-----

* [condor_chirp - HTCondor Chirp Command-Line Tool](http://research.cs.wisc.edu/htcondor/manual/current/condor_chirp.html)
* [HTCondor Chirp](https://research.cs.wisc.edu/htcondor/chirp/)
* [Chirp Official Website](http://ccl.cse.nd.edu/software/chirp/)
