# File

function save_HTML(str::String, outFile::String)
    io = open(outFile, "w");
    write(io, str);
    close(io);

    return outFile
end
