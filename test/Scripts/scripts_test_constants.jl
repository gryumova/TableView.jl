function read_file(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

const test_1 = read_file("./Scripts/test1.txt")
const test_2 = read_file("./Scripts/test2.txt")
const test_3 = read_file("./Scripts/test3.txt")
const test_4 = read_file("./Scripts/test4.txt")