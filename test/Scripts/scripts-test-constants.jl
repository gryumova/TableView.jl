function readFile(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

const test_1 = readFile("test1.txt")
const test_2 = readFile("test2.txt")
const test_3 = readFile("test3.txt")
const test_4 = readFile("test4.txt")