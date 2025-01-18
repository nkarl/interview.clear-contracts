/*
 * REFERENCE: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Typed_arrays
 *  1. `ArrayBuffer`
 *  2. `TypedArray` (Int8-32, UInt8-32, Float16-64, etc.)
 *  3. `DataView`
 *
 *  In short, typed arrays are views specialized for some predefined byte data. `DataView` is more low-leveled, when we need to manipulate bytes arbitrarily.
 *  An `Uint8Array` is equivalent to `UInt8 DataView`.
 */

/*
 * BASICS: Create, Read, Update
 */

/*
 * CREATE
 */
const BUF_SIZE = 8;
const buffer = new ArrayBuffer(BUF_SIZE); // creates a small buffer of 8 bytes
const uint8View = new Uint8Array(buffer); // creates a `ArrayView` of 8-bit unsigned integers

/*
 * READ
 */
// Accesses Buffer via View, reads data in each slot
console.log("Reading the buffer as a UInt8 ArrayView");
console.log(uint8View);


/*
 * UPDATE
 */
// Sets the value of each byte in the View.
uint8View[0] = 0x8
uint8View[1] = 0xF
uint8View[2] = 121
uint8View[3] = 128
uint8View[4] = 'C' // a string is not recognized. The individual Char must be set as an ASCII-compliant numerical value.
uint8View[5] = 0
uint8View[6] = 1
uint8View[7] = 2

/*
 * Or equivalently uses the `.set()` method. Requires
 *  - an array of new values to be "set"
 *  - an index to begin setting. BE CAREFUL about index out of bound error.
 */
var newData = [1, 2, 3];
uint8View.set([1, 2, 3], uint8View.length - newData.length);

console.log("Reading 8-bit UInt View, with the new set entries.");
console.log(uint8View);

/*
 * READ, from an arbitrary DataView
 */
// creates an arbitrary DataView
const dv = new DataView(buffer);
// steps uniformly through each chunk (fit to a `Uint8` type) and interprets it with proper string format and padding.
for (let i = 0; i < uint8View.length; i++) {
    const radix = 10; // the base of the number system, oct-8, dec-10, hex-16
    const a = dv
        .getUint8(i)
        .toString(radix)
        .padStart(8 / Math.log2(radix), "0");
    console.log(a);
}

// equivalent
let radix = 2;
let bytes = Array.from({ length: BUF_SIZE }, (_, i) => dv
    .getUint8(i)
    .toString(radix)
    .padStart(8 / Math.log2(radix), "0"));
console.log("in bin-2 ", bytes.join(' '));
radix = 8;
bytes = Array.from({ length: BUF_SIZE }, (_, i) => dv
    .getUint8(i)
    .toString(radix)
    .padStart(2 + 8 / Math.log2(radix), "0"));
console.log("in oct-8 ", bytes.join(' '));
radix = 10;
bytes = Array.from({ length: BUF_SIZE }, (_, i) => dv
    .getUint8(i)
    .toString(radix)
    .padStart(2 + 8 / Math.log2(radix), "0"));
console.log("in dec-10", bytes.join(' '));
radix = 16;
bytes = Array.from({ length: BUF_SIZE }, (_, i) => dv
    .getUint8(i)
    .toString(radix)
    .padStart(8 / Math.log2(radix), "0"));
console.log("in hex-16", bytes.join(' '));
radix = 32;

/*
 * DECODE to UTF String.
 */

// into a UTF-8 String
uint8View.set([65, 66, 67, 97, 98, 99]); // Sets the Uint8Array View
//dv.setInt8([65, 66, 67, 97, 98, 99]); // Sets the arbitrary DataView by its method setInt8
const textUTF_8 = new TextDecoder().decode(dv);
console.log(textUTF_8);

// into a UTF-16 String
const textUTF_16 = String.fromCharCode.apply(String, uint8View);
console.log(textUTF_16);

/*
 * READ the buffer as a different typed view.
 */
console.log("Reading the buffer as a UInt16 ArrayView");
const uint16View = new Uint16Array(buffer);
console.log(uint16View);

