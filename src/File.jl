function readData(fileName::String)
    io = open(fileName, "r")
    s = read(io, String)
    close(io)

    return s
end

function saveHTML(str::String, outFile::String)
    io = open(outFile, "w");
    write(io, str);
    close(io);

    return outFile
end
