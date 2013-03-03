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

    ![alt text](errplane-ios-dist/importLib.png "Import Library Files")

4.  Select the `errplane-ios-dist` directory that was created when you unzipped, checkmark the 'Destination' check box and select the 'Create groups for any added folders' radio button.
    Also make sure to select the target[s] that will use the library.
5.  After clicking 'Add', the headers will be viewable by your source and the library will already be set to link with your target.  You're now ready to start using it. 

Initializing the library
------------------------
The library is initialized with the following arguments:

    url: the base Errplane url (e.g. - http://errplane.com/)
    api: your api_key used to verify Errplane usage
    app: your app name configured in Errplane
    env: the environment you are using (usually one of: production, staging, development)

Using these values the library is initialized using:

    BOOL success = [Errplane setupWithUrl:url apiKey:apiKey appKey:appKey environment:envKey];

success is true if none of the values passed in were nil and if the url was valid.

Additionally, to set a session user to better trace exceptions reported to Errplane the following can be used:

    [Errplane setSessionUser:@"string that identifies the current user"];

Reporting
---------
There are six methods used for reporting - use the method[s] that makes the most sense for your application.  The following are simple examples for each:

    // simple reporting (default int value of 1 is sent to Errplane)
    [Errplane report:@"user logged in"];
    
    // reporting providing your own useful int value
    [Errplane report:@"hours_since_last_login" withInt:10];
    
    // reporting providing your own useful double value
    [Errplane report:@"avg_usage_pcnt" withDouble: 99.9];
    
    // reporting providing your own useful context (uses default int value of 1)
    [Errplane report:@"problem_with_server" withContext:@"Delayed Server Request"];
    
    // reporting providing your own useful context and int value
    [Errplane report:@"slow_processing" withInt: 2500
                           andContext:@"Slow Processing"];
    
    // reporting providing your own useful context and double value
    [Errplane report:@"average_response_time"
                           withDouble: 192.75
                           andContext:@"Average Response Time"];


Exception Reporting
-------------------
There are four basic methods for reporting exceptions.  Again, use the ones that make the most sense for your application.  The examples assume `exception` is a populated `NSException`.

    // basic default
    [Errplane reportException:exception];
    
    // with custom data
    [Errplane reportException:exception withCustomData:@"custom data for you to pass in can be json"];
    
    // hash override
    [Errplane reportException:exception withHash:@"hash this"];
    
    // hash override with custom data
    [Errplane reportException:exception withHash:@"hash this" andCustomData:
                      @"more custom data"];


Customizing How Exceptions Get Grouped
--------------------------------------
