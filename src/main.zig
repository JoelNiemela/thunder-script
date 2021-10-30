const std = @import("std");

const Token = union(enum) {
    Let,
    LPar,
    RPar,
    LBrace,
    RBrace,
    LBracket,
    RBracket,
    Eq,
    LT,
    GT,
    LE,
    GE,
    NE,
    Assign,
    Arrow,
    Colon,
    Semicolon,
    Dot,
    Comma,
    Id,
    Int: i32,
    Float: f32,
    String: []u8,
    Mul,
    Div,
    Add,
    Sub,
    Mod,
    Ptr,
    Ref,
    Maybe,
};

const Lexer = struct {
    file: std.fs.File,
    file_buffer: [std.mem.page_size]u8,
    bytes_read: usize,
    next_index: usize,

    pub fn init(fname: []const u8) !Lexer {
        var file = try std.fs.cwd().openFile(fname, std.fs.File.OpenFlags{ .read = true });
        var lexer = Lexer{
            .file = file,
            .file_buffer = undefined,
            .bytes_read = 0,
            .next_index = 0,
        };

        lexer.rebuffer();

        return lexer;
    }

    pub fn deinit(self: @This()) void {
        self.file.close();
    }

    pub fn nextChar(self: *@This()) ?u8 {
        if (self.next_index < self.bytes_read) {
            self.next_index += 1;
            return self.file_buffer[self.next_index - 1];
        }

        if (self.bytes_read == 0) {
            return null;
        }

        self.next_index = 0;
        self.rebuffer();

        return self.nextChar();
    }

    pub fn printAll(self: *@This()) void {
        const stdout = std.io.getStdOut().writer();

        self.rebuffer();
        while (self.bytes_read > 0) {
            try stdout.print("{s}", .{self.file_buffer[0..self.bytes_read]});
            self.rebuffer();
        }
    }

    fn rebuffer(self: *@This()) void {
        self.bytes_read = self.file.read(self.file_buffer[0..]) catch 0;
    }
};

pub fn next() Token {}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var lexer = try Lexer.init("src.st");
    defer lexer.deinit();

    var char: ?u8 = lexer.nextChar();
    while (char != null) : (char = lexer.nextChar()) {
        try stdout.print("{c}", .{char});
    }
}
