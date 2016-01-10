SELECT `x`, `y`, `z`, `blocktype`, `blockmeta` 
FROM @tablename
WHERE `x` > $minX
AND `y` > $minY
AND `z` > $minZ
AND `x` < $maxX
AND `y` < $maxY
AND `z` < $maxZ
AND `cause` = $cause
AND `time` > $time;