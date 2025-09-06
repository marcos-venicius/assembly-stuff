extern long convert_to_integer(char *buffer, int size) {
    long result = 0;
    long n = 1;

    for (int i = 0; i < size; ++i) {
        char c = buffer[size - i - 1];

        if (c < '0' || c > '9') continue;

        result += (c - '0') * n;

        n *= 10;
    }

    return result;
}
