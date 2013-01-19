<?php

/******
 * This build pattern works like so:
 *
 * At deploy time, all binaries/libs/etc are installed into:
 *
 * /app/vendor
 *
 * At build time, dependencies are installed into /app/vendor and the build artifacts are directed at /tmp/app/vendor which is tgz'd as the artifact
 */

define('BUILD_DIR', __DIR__ . '/build');
define('SRC_DIR', BUILD_DIR . '/src');
define('ARTIFACTS_DIR', BUILD_DIR . '/artifacts');

if (!file_exists(SRC_DIR)) mkdir(SRC_DIR, 0755, true);
if (!file_exists(ARTIFACTS_DIR)) mkdir(ARTIFACTS_DIR, 0755, true);

foreach ($argv as $buildFile) {
    if ($buildFile === 'build.php') continue;

    echo "Processing $buildFile...\n";
    $buildInfo = json_decode(file_get_contents($buildFile), true);
    build($buildInfo['name'], $buildInfo['version'], $buildInfo['sourceUrl'], $buildInfo['buildScript'], $buildInfo['dependencies']);
}

function build($name, $version, $sourceUrl, $buildScript, $dependencies = array())
{
    $versionedAppName = "{$name}-{$version}";
    $tgzFilename = "{$versionedAppName}.tgz";

    $sourceUrlInfo = pathinfo($sourceUrl);
    $dlFilename = $sourceUrlInfo['basename'];
    $dlPath = SRC_DIR . '/' . $dlFilename;
    $srcDir = SRC_DIR . '/' . $versionedAppName;
    $artifactFilePath = ARTIFACTS_DIR . '/' . $tgzFilename;

    if (!file_exists($srcDir) && !file_exists($dlPath))
    {
        echo "Downloading {$sourceUrl}\n";
        copy($sourceUrl, $dlPath);
    }
    if (!file_exists($srcDir))
    {
        mkdir($srcDir, 0755, true);
        echo "Exctracting {$sourceUrl}\n";
        `tar -zxf {$dlPath} --strip-components 1 -C {$srcDir}`;
    }

    if (count($dependencies))
    {
        $depsInstallCommands = array();
        foreach ($dependencies as $depUrl) {
            $depsInstallCommands[] = "curl --silent --location {$depUrl} | tar xz -C /app/vendor";
        }
        $depsInstallCommand = join(' && ', $depsInstallCommands);
        $buildScript = "{$depsInstallCommand} \\\n  && {$buildScript}";
    }

    $buildScript = str_replace('%%VULCAN_BUILD_CONFIGURE_OPTIONS%%', '--prefix=/app/vendor --with-libs=/app/vendor:/', $buildScript);
    $buildScript = 'export DESTDIR=/tmp && mkdir -p ${DESTDIR}/app/vendor && ' . $buildScript;

    $vulcanCommand = <<<BUILD
vulcan build -v \
    -s {$srcDir} \
    -c '{$buildScript}' \
    -p '/tmp/app/vendor' \
    -o {$artifactFilePath}
BUILD;
    print "\n{$vulcanCommand}\n\n";
}
