module File

function readData(fileName)
    io = open(fileName, "r")
    s = read(io, String)
    close(io)

    return s
end

function saveHTML(str, outFile)
    io = open(outFile, "w");
    write(io, str);
    close(io);

    outFile
end
end