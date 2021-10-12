# SkinTracker

Skin condition development, tracked over time

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

3. Go to Xcode > Window > Organizer. There, you'll see the latest archive that you just did.

4. Click Validate App. Automatic certificate signing. Press next through everything and let it do its thing.

5. Click Distribute App. Use App Store Connect. Export, don't upload. Automatic certificate signing. Press next through
   everything and let it do its thing. Save the file in the usual place you put it.

6. Open the Transporter app, from Apple. Click the + in the top left, and go to the .ipa file that was produced just now
   in the previous step. Click Deliver.

7. Go to [App Store Connect](https://appstoreconnect.apple.com) and find the app. Go to the TestFlight tab. You should
   see it processing there. If it disappears, that might mean it failed some automatic checks. Apple will email you
   about that, so check your email.

8. Pretty quickly the processing should complete. You'll have to do some compliance stuff related to encryption and US
   export regulations. Generally you are subject to these regulations. It's not a problem.
    - Does your app use encryption? **Yes**
    - Does your app qualify for exemptions? **No**
    - Does your app implement proprietary encryption algorithms? **No**
    - Does your app implement standard encryption algorithms instead of using Apple implementations? **No**

9. Submit your app for review. To do this, click the name of your "External Testing" group. At the bottom of the page,
   you should see a list titled "Builds". On the right of that title should be a "+" button. Select your recently
   uploaded and processed build, and then click "Add".

9. Your build will spend some time waiting for review from Apple. After that, with the public link enabled, people can
   start using and testing the app through Apple's TestFlight app.

### What's up next

- New Feature - View a timelapse of your photos
- Defect - Intuitive way to dismiss the text popup when adding entries for recording
- Defect - More feedback when pressing the save/update button
- Defect - Gallery doesn't update with the latest entry when one is added
- Defect - Graphs don't update according to the latest entry when one is added
- Feature Enhancement - Showing users how to set up proper lighting for photo taking
- Feature Enhancement - Per-region charts for spot counts
- Performance - Remove the need to load all the data into memory immediately
- Performance - Remove the need to sort all the data after it gets loaded into memory
- Onboarding - Tips for those who are new to looking after their skin
- Onboarding - Graph doesn't make sense until you have a decent amount of data. Do something more engaging for new users
- Maintenance - UI tests