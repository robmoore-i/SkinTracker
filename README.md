# SkinTracker

Skin outbreak tracking

## Problem: Outbreak Tracking

When it came to my skin, I always found it hard to answer these questions:
- Is my skin actually getting better or will I look like a spotty 18 year old forever?
- Are my theories about my skin actually true, or could they be disproved by actually recording data about my skin's health over time?

Existing managed solutions, have these problems:
    - Bad form factor
    - Require excessive customization
    - Lack visualizations
    - Fail to motivate commitment
    - Try to sell things to me

Ad-hoc tracking solutions suffer from all but the last of those problems. I never created one because of their main problem: Like many ad-hoc solutions in general, they are high-effort, low-reward.

## Developer Documentation

### Release to TestFlight

1. In Xcode, ensure that the (Version Number, Build Version) pair is unique. In Xcode if you select the "SkinTracker"
   blue document icon at the top of the left-side file-tree view, and go to the 'General' tab, there is a section called
   "Identity" which contains the fields "Version" and "Build".

3. Click Xcode > Product > Archive. This takes a while. Note that this option is grayed out unless your scheme has a
   destination of “iOS Device” or an actual iOS device.

4. Go to Xcode > Window > Organizer. There, you'll see the latest archive that you just did.

5. Click Validate App. Automatic certificate signing. Press next through everything and let it do its thing.

6. Click Distribute App. Use App Store Connect. Export, don't upload. Automatic certificate signing. Press next through
   everything and let it do its thing. Save the file in the usual place you put it.

7. Open the Transporter app, from Apple. Click the + in the top left, and go to the .ipa file that was produced just now
   in the previous step. Click Deliver.

8. Go to [App Store Connect](https://appstoreconnect.apple.com) and find the app. Go to the TestFlight tab. You should
   see it processing there. If it disappears, that might mean it failed some automatic checks. Apple will email you
   about that, so check your email.

9. Pretty quickly the processing should complete. You'll have to do some compliance stuff related to encryption and US
   export regulations. Generally you are subject to these regulations. It's not a problem.
    - Does your app use encryption? **Yes**
    - Does your app qualify for exemptions? **No**
    - Does your app implement proprietary encryption algorithms? **No**
    - Does your app implement standard encryption algorithms instead of using Apple implementations? **No**

10. Submit your app for review. To do this, click the name of your "External Testing" group. At the bottom of the page,
    you should see a list titled "Builds". On the right of that title should be a "+" button. Select your recently
    uploaded and processed build, and then click "Add".

11. Your build will spend some time waiting for review from Apple. After that, with the public link enabled, people can
    start using and testing the app through Apple's TestFlight app.
