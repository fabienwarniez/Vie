#!/usr/bin/env php
<?php

$directory = "../Patterns/";
$validRules = ['B3/S23', 'b3/s23', '23/3', 's23/b3'];

$directoryHandler = opendir($directory);

$fileArray = array();

while (false !== ($filename = readdir($directoryHandler))) {
    $format = null;
    $name = null;
    $size = null;
    $data = '';
    if (strpos($filename, '.rle') !== false) {
        $format = 'rle';

        $lines = file(sprintf("%s%s", $directory, $filename), FILE_IGNORE_NEW_LINES);

        foreach ($lines as $line) {
            if (strpos($line, '#N') === 0) {
                $explodedNameLine = explode(' ', $line);
                if (count($explodedNameLine) >= 2) {
                    array_shift($explodedNameLine);
                    $name = implode(' ', $explodedNameLine);
                } else {
                    $name = substr($filename, 0, strlen($filename) - 4);
                    echo sprintf("No name, using file name instead: %s \n", $name);
                }
            } elseif (strpos($line, 'x = ') === 0) {
                list($columns, $rows, $rule) = sscanf($line, "x = %i, y = %i, rule = %s");

                if (in_array($rule, $validRules) && $columns > 0 && $rows > 0 && $columns <= 90 && $rows <= 120) {
                    $size = sprintf('%d|%d', $columns, $rows);
                }
            } elseif (strpos($line, '#') !== 0) {
                $data .= $line;
            }
        }
    } elseif (strpos($filename, '.lif') !== false) {
        // ignore .lif files for now
        continue;
    } elseif (strpos($filename, '.cells') !== false) {
        // ignore .cells files for now
        continue;
    } else {
        // unrecognized extension
        continue;
    }


    if ($format && $name && $size && $data) {
        $fileArray []= sprintf('%s|%s|%s|%s|%s', $filename, $format, $name, $size, $data);
    } else {
        echo sprintf("Incomplete file not added to index: %s\n", $filename);
    }
}

file_put_contents('../Vie/Resources/patterns.dat', implode("\n", $fileArray));

echo "Successfully wrote index file.\n";
