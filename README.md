Errplane
========
This library integrates your applications with [Errplane](http://errplane.com), a cloud-based tool for handling exceptions, log aggregation, uptime monitoring, and alerting.

Installing the library
----------------------
The easiest way to get started is to download the prebuilt universal static library with headers from github at [https://github.com/errplane/errplane-ios/tree/master/errplane-ios-dist](errplane-ios.zip).
This library was built with support for arm6 and arm7 architectures and supports iOS 4.2 and above.  After downloading follow these steps to import it into your project.

1.  Unzip the downloaded zip file - this will create a directory called `errplane-ios-dist`.  The directory will contain three files:

    `EPDefaultExceptionHash.h` - used to override the default exception hash behavior (more on that later)
    
    `Errplane.h` - the entrypoint into the errplane-ios library
    
    `liberrplane-ios.<version>.a` - the universal static library for simulators and devices

2.  Open your project in Xcode and click on File-->Add Files to "YourProjectName"...
3.  You should see a screen that looks like:

    ![alt text](https://github.com/errplane/errplane-ios/blob/master/errplane-ios-dist/importLib.png "Import Library Files")

4.  Select the `errplane-ios-dist` directory that was created when you unzipped, checkmark the 'Destination' check box and select the 'Create groups for any added folders' radio button.
    Also make sure to select the target[s] that will use the library.

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
