function [rawData, rawInfo, tiffInfo] = loadDng(rawFileName)
    rawInfo = imfinfo(rawFileName);
    tiffInfo = rawInfo.SubIFDs{1};
    t = Tiff(rawFileName,'r');
    offsets = getTag(t,'SubIFD');
    setSubDirectory(t,offsets(1));
    cfa = read(t);
    rawData = double(cfa);
end