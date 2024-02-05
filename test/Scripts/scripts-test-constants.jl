function readFile(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

const test_1 = readFile("./Scripts/test1.txt")
const test_2 = readFile("./Scripts/test2.txt")
const test_3 = readFile("./Scripts/test3.txt")
const test_4 = readFile("./Scripts/test4.txt")