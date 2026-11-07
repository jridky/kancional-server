<?php
    $lockfile = "/tmp/fullscreen-restart-lock";
    $cooldown = 300;

    if (file_exists($lockfile) && (time() - filemtime($lockfile)) < $cooldown) {
        exit;
    }

    touch($lockfile);
    shell_exec("sudo /usr/bin/systemctl restart startup");
?>
