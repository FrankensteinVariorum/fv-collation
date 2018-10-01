# Harvesting Annotations from Hypothesis

Uses the <hypothes.is> API to search for annotations from the Frankenstein group.

## Use

Requires a [Hypothesis Developer API key](https://hypothes.is/account/developer) saved to `hypothetsis/annotation_harvesting/.hypothesis_token`. 

Running `harvest_annotations.R` will produce `annotations.json`

## Other Files

`hypothesis.json` is the OpenAPI/Swagger specification for the hypoethes.is API and the script uses this to autogetnerate the proper GET calls.
