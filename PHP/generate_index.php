<?php

$directory = "../Patterns/";

$directoryHandler = opendir($directory);

$fileArray = array();

while (false !== ($filename = readdir($directoryHandler)))
{
    $format = null;
    $name = null;
    $size = null;
    $data = null;

    if (strpos($filename, '.rle') !== false)
    {
        $format = 'rle';

        $lines = file(sprintf("%s%s", $directory, $filename), FILE_IGNORE_NEW_LINES);

        foreach ($lines as $line)
        {
            if (strpos($line, '#N') === 0)
            {
                $explodedNameLine = explode(' ', $line);
                if (count($explodedNameLine) >= 2)
                {
                    array_shift($explodedNameLine);
                    $name = implode(' ', $explodedNameLine);
                }
                else
                {
                    $name = substr($filename, 0, strlen($filename) - 4);
                    echo sprintf("No name, using file name instead: %s \n", $name);
                }
            }
            else if (strpos($line, 'x = ') === 0)
            {
                list($columns, $rows) = sscanf($line, "x = %i, y = %i,%s");

                if ($columns > 0 && $rows > 0)
                {
                    $size = sprintf('%dx%d', $columns, $rows);
                }
                else
                {
                    echo sprintf("Bad format for size: %s\n", $line);
                }
            }
            else if (strpos($line, '#') !== 0)
            {
                $data = $line;
            }
        }
    }
    else if (strpos($filename, '.lif') !== false)
    {
        // ignore .lif files for now
        continue;
    }
    else if (strpos($filename, '.cells') !== false)
    {
        // ignore .cells files for now
        continue;
    }
    else
    {
        // unrecognized extension
        continue;
    }

    if ($format && $name && $size && $data)
    {
        $fileArray []= sprintf('%s|%s|%s|%s|%s', $filename, $format, $name, $size, $data);
    }
    else
    {
        echo sprintf("Incomplete file not added to index: %s\n", $filename);
    }
}

file_put_contents('../Vie/Resources/patterns.dat', implode("\n", $fileArray));

echo "Successfully wrote index file.\n";