function readFile(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

const test_1 = readFile("test/Scripts/test1.txt")
const test_2 = readFile("test/Scripts/test2.txt")
const test_3 = readFile("test/Scripts/test3.txt")
const test_4 = readFile("test/Scripts/test4.txt")