function new = padToLength(old, newLength)
% pads an array with trailing zeros to a given length
oldLength = length(old);
if (oldLength < newLength)
    new = padarray(old, (newLength-oldLength), 'post');
else
    new = old;
end