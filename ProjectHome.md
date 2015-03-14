# Stellar Locus Regression #

An IDL implementation of the SLR method of FW High, CW Stubbs, A Rest, B Stalder & P Challis ([2009](http://adsabs.harvard.edu/abs/2009AJ....138..110H)).

## Get Started ##

SLR version 1.1 is now available.  See "featured downloads".

## Get the Manual ##

The latest manual can be found in the distribution itself in the subdirectory `<install-dir>/slr-v*/docs/manual`.  Or, you can just get the manual like this:

```
svn checkout http://stellar-locus-regression.googlecode.com/svn/trunk/docs/manual/ slr_manual
```

## Cliffs notes ##

Stellar Locus Regression (SLR) is a simple way to **calibrate colors at the 1-2% level, and magnitudes at the sub-5% level as limited by 2MASS, without the traditional use of standard stars**.  With SLR, stars in any field are "standards."  This is an entirely new way to calibrate photometry using a [fundamental property of all stars](http://en.wikipedia.org/wiki/Color-color_diagram), and it's immensely liberating.

SLR exploits the simple fact that most stars lie along a well defined line in color-color space called the _stellar locus_.  Cross-match point-sources in flattened images taken through different passbands and plot up all color vs color combinations, and you will see the stellar locus with little effort.  SLR calibrates colors by fitting these colors to a standard line.  Cross-match with 2MASS on top of that, and SLR will deliver calibrated _magnitudes_ as well.

### SLR corrects for everything you care about ###

SLR makes one wholesale correction for all the confounding effects you care about: attenuation by the atmosphere, common-mode aperture corrections, Galactic reddening, and any residual zeropoint errors that are common across the image, _known or unkown_.  It does all this in one single step, making calibrations incredibly easy.

### SLR delivers percent-level calibrations in non-photometric conditions ###

Clouds are no match for SLR.  Use SLR to stabilize zeropoints for images taken through bad or variable photometric conditions.  Given this remarkable feature of SLR, there's actually no excuse not to use it as your primary calibration tool.

### No standard star observations means more science time ###

SLR frees you entirely from having to observe standard stars.  This means you spend more telescope time on your science fields.

### Illustration ###

The figure below illustrates the basic idea using real data.  Here we're calibrating photometry taken from the Magellan 6.5 m telescope's IMACS instrument.

![http://lh5.ggpht.com/_el3vviI4Hmo/TJ6FtsjUq1I/AAAAAAAAFz0/ZzYmHH1ynV4/s800/slr.png](http://lh5.ggpht.com/_el3vviI4Hmo/TJ6FtsjUq1I/AAAAAAAAFz0/ZzYmHH1ynV4/s800/slr.png)

Use SLR to calibrate your data from scratch, or to test your existing calibrations.  SLR's systematic uncertainties are fundamentally different from those of the standard methods, so it is a powerful tool to complement the traditional analysis.

SLR has great promise as a primary calibration tool for any program, from pointed and short term campaigns to the upcoming generation of large-scale surveys.