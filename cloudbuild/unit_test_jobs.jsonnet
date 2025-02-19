local base = import 'templates/base.libsonnet';
local gpus = import 'templates/gpus.libsonnet';

local image = std.extVar('image');
local tagName = std.extVar('tag_name');
local gcsBucket = std.extVar('gcs_bucket');

local unittest = base.BaseTest {
  // Configure job name.
  frameworkPrefix: "tf",
  modelName: "keras-nlp",
  mode: "unit-tests",
  timeout: 3600, # 1 hour, in seconds

  // Set up runtime environment.
  image: image,
  imageTag: tagName,
  accelerator: gpus.teslaV100,
  outputBucket: gcsBucket,

  entrypoint: [
    'bash',
    '-c',
    |||
      # Run whatever is in `command` here.
      cd keras-nlp
      ${@:0}
    |||
  ],
  command: [
    'pytest',
    'keras_nlp',
  ],
};

std.manifestYamlDoc(unittest.oneshotJob, quote_keys=false)
