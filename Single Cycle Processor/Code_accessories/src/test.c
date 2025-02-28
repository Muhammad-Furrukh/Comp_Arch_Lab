int main() {
    __asm__("la sp, _sp");
    int a = 5;
    int b = 10;
    int c = a + b;      // c = 15
    int d = c - a;      // d = 10
    int e = 0;          // e = d * b (10 * 10 = 100)
    int f = 0;          // f = e / a (100 / 5 = 20)

    // Multiply d * b using a loop
    for (int i = 0; i < b; i++) {
        e += d;
    }

    // Divide e / a using a loop
    while (e >= a) {
        e -= a;
        f++;
    }

    // endless loop
   while(1){}
}