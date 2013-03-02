Errplane
========
This library integrates your applications with [Errplane](http://errplane.com), a cloud-based tool for handling exceptions, log aggregation, uptime monitoring, and alerting.

Using the library
-----------------
The library can be used by either including all source files in your project or by including the Errplane.h header and (optionally) the EPDefaultExceptionHash.h header and linking with the library.

All usage of the library requires only the import of Errplane.h.

Initializing the library
------------------------
The library is initialized with the following arguments:
    url: the base Errplane url (e.g. - http://errplane.com/)
    api: your api_key used to verify Errplane usage
    app: your app name configured in Errplane
    env: the environment you are using (usually one of: production, staging, development)

Once these are known the library is initialized using:
    BOOL success = [Errplane setupWithUrl:url apiKey:apiKey appKey:appKey environment:envKey];

success is true if none of the values passed in were nil and if the url was valid.


Reporting
---------

Exception Reporting
-------------------

Customizing How Exceptions Get Grouped
--------------------------------------
