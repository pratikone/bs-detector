function isSame = mystrcmp(str1, str2)
isSame = numel(str1) == numel(str2) && all(str1 == str2);
end  