# SkinTracker

Chronic acne status tracking

## Problem: Tracking

- Existing managed solutions, have these problems:
  - Bad form factor
  - Require excessive customization
  - Lack visualizations
  - Fail to motivate commitment
  - Try to sell things to me
  
Ad-hoc tracking solutions suffer from all but the last of those problems.

## Release to TestFlight

1. In Xcode, ensure that the (Version Number, Build Version) pair is unique.

2. Click Xcode > Product > Archive. This takes a while.

3. Go to Xcode > Window > Organizer.  There, you'll see the latest archive that you just did.

4. Click Validate App. Automatic certificate signing. Press next through everything and let it do its thing.

5. Click Distribute App. Use App Store Connect. Export, don't upload. Automatic certificate signing. Press next through
   everything and let it do its thing. Save the file in the usual place you put it.
   
6. Open the Transporter app, from Apple. Click the + in the top left, and go to the .ipa file that was produced just 
   now in the previous step. Click Deliver.
   
7. Go to [App Store Connect](https://appstoreconnect.apple.com) and find the app. Go to the TestFlight tab. You should
   see it processing there. If it disappears, that might mean it failed some automatic checks. Apple will email you 
   about that, so check your email.
   
8. Pretty quickly the processing should complete. You'll have to do some compliance stuff related to encryption and
   US export regulations. Generally you are subject to these regulations. It's not a problem.
   
9. Your build will spend some time waiting for review from Apple. After that, you can enable the public link and people
   can start using and testing the app through TestFlight.