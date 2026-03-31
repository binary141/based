const std = @import("std");
const based_zig = @import("based_zig");
const Allocator = std.mem.Allocator;

const int_to_letters = [65]u8{
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '-', '_', '=',
};

const PADDING: u8 = '=';

// f -> []byte{0,1,1,0,0,1,1,0}
pub fn intToBits(i: u8) [8]u8 {
    const a: u8 = i >> 7 & 0x1;
    const b: u8 = i >> 6 & 0x1;
    const c: u8 = i >> 5 & 0x1;
    const d: u8 = i >> 4 & 0x1;
    const e: u8 = i >> 3 & 0x1;
    const f: u8 = i >> 2 & 0x1;
    const g: u8 = i >> 1 & 0x1;
    const h: u8 = i >> 0 & 0x1;

    return [8]u8{a, b, c, d, e, f, g, h};
}

test "intToBits Test" {
    const res: [8]u8 = intToBits('f');

    try std.testing.expectEqual([8]u8{0, 1, 1, 0, 0, 1, 1, 0}, res);
}

pub fn base64Encode(allocator: std.mem.Allocator, chars: []const u8) !std.ArrayList(u8) {
    const bitWidth: usize = 6;

    var bits: std.ArrayList(u8) = .empty;
    defer bits.deinit(allocator);

    for (chars) |char| {
        const letterBits:[8]u8 = intToBits(char);

        for (letterBits) |letterBit| {
            try bits.append(allocator, letterBit); 
        }
    }

    if (bits.items.len == 0) {
        return bits;
    }

    var paddingNeeded: usize = bitWidth - (bits.items.len % bitWidth);

    if (paddingNeeded == bitWidth) {
        paddingNeeded = 0;
    }

    for (0..paddingNeeded) |_| {
       try bits.append(allocator, 0);
    }

    var letters: std.ArrayList(u8) = .empty;

    var i: usize = 0;

    while (i <= bits.items.len - bitWidth) : (i += bitWidth) {
        var idx: u8 = bits.items[i] << 5;
        idx += bits.items[i+1] << 4;
        idx += bits.items[i+2] << 3;
        idx += bits.items[i+3] << 2;
        idx += bits.items[i+4] << 1;
        idx += bits.items[i+5] << 0;

        const letter: u8 = int_to_letters[idx];

        try letters.append(allocator, letter); 
    }

    for (0..(paddingNeeded/2)) |_| {
        try letters.append(allocator, PADDING);
    }

    return letters;
}

pub fn main() !void {
    const str = "based";

    const allocator = std.heap.page_allocator;

    var encoded = try base64Encode(allocator, str);
    defer encoded.deinit(allocator);
    std.debug.print("{s}\n", .{encoded.items});
}


test "base64 simple test" {
    const str = "hello";
    const allocator = std.heap.page_allocator;

    var encoded = try base64Encode(allocator, str);
    defer encoded.deinit(allocator);

    try std.testing.expectEqualStrings("aGVsbG8=", encoded.items);
}

test "base64 complex test" {
    const str = "hello, this is going to be some sort of a larger string for it to try to do";
    const allocator = std.heap.page_allocator;

    var encoded = try base64Encode(allocator, str);
    defer encoded.deinit(allocator);

    try std.testing.expectEqualStrings("aGVsbG8sIHRoaXMgaXMgZ29pbmcgdG8gYmUgc29tZSBzb3J0IG9mIGEgbGFyZ2VyIHN0cmluZyBmb3IgaXQgdG8gdHJ5IHRvIGRv", encoded.items);
}
