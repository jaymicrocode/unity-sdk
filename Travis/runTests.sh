#! /bin/sh
project="unity-sdk-travis"

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  echo '$TRAVIS_PULL_REQUEST is false, running tests'
  openssl aes-256-cbc -K $encrypted_984f19857b4c_key -iv $encrypted_984f19857b4c_iv -in Config.json.enc -out Travis/UnityTestProject/Assets/StreamingAssets/Config.json -d

  echo "Running UnitySDK Tests...  pwd: $(pwd)"
  /Applications/Unity/Unity.app/Contents/MacOS/Unity \
    -batchmode \
    -nographics \
    -silent-crashes \
    -logFile $(pwd)/integrationTests.log \
    -projectPath $(pwd)/Travis/UnityTestProject \
    -executemethod RunUnitTest.All \
    -quit
  if [ $? = 0 ] ; then
    echo "UnitTest COMPLETED! Exited with $?"
    exit 0
  else
    echo "UnitTest FAILED! Exited with $?"
    echo 'Logs tests'
    cat $(pwd)/integrationTests.log
    exit 1
  fi
else
  echo '$TRAVIS_PULL_REQUEST is not false ($TRAVIS_PULL_REQUEST), skipping tests'
fi
