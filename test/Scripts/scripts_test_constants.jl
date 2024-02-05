function read_file(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

const DIFFERENT_STYLE = read_file("./Scripts/differentStyle.txt")
const EMPTY_DICT_RESIZE = read_file("./Scripts/emptyDictResize.txt")
const EMPTY_DICT_NOT_RESIZE = read_file("./Scripts/emptyDictNotResize.txt")
const DIFFERENT_FILTER = read_file("./Scripts/differentFiter.txt")