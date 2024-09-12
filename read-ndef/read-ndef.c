#include <nfc/nfc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const nfc_modulation nmMifare = {
    .nmt = NMT_ISO14443A,
    .nbr = NBR_106,
};

void print_hex(const uint8_t *data, const size_t len) {
    for (size_t i = 0; i < len; i++) {
        printf("%02x ", data[i]);
    }
    printf("\n");
}

int main(void) {
    nfc_device *pnd;
    nfc_context *context;
    nfc_target nt;
    uint8_t command[2];
    uint8_t response[16];
    uint8_t ndef_data[1024];
    int res, offset = 0;

    nfc_init(&context);
    if (context == NULL) {
        printf("ERROR: Unable to init libnfc.\n");
        return 1;
    }

    pnd = nfc_open(context, NULL);
    if (pnd == NULL) {
        printf("ERROR: Unable to open NFC device.\n");
        return 1;
    }

    if (nfc_initiator_init(pnd) < 0) {
        nfc_perror(pnd, "nfc_initiator_init");
        return 1;
    }
    printf("NFC reader: %s opened\n", nfc_device_get_name(pnd));

    if (nfc_initiator_select_passive_target(pnd, nmMifare, NULL, 0, &nt) <= 0) {
        printf("No NFC tag found.\n");
        return 1;
    }
    printf("NFC tag detected.\n");

    // Read all blocks until the end of the NDEF message
    for (int block = 4; block < 64; block++) { // Adjust the upper limit as needed
        command[0] = 0x30; // Read command for NTAG
        command[1] = block; // Block number

        res = nfc_initiator_transceive_bytes(pnd, command, sizeof(command), response, sizeof(response), 0);
        if (res < 0) {
            nfc_perror(pnd, "nfc_initiator_transceive_bytes");
            return 1;
        }

        memcpy(ndef_data + offset, response, res);
        offset += res;

        // Check if we have reached the end of the NDEF message
        if (response[0] == 0xFE) { // Terminator TLV
            break;
        }
    }

    printf("NDEF data:\n");
    print_hex(ndef_data, offset);

    // Skip trailing zeroes
    int end = offset;
    while (end > 0 && ndef_data[end - 1] == 0x00) {
        end--;
    }

    // Parse NDEF data (assuming it's a text record)
    if (ndef_data[0] == 0x03) { // NDEF message TLV
        size_t ndef_len = ndef_data[1];
        uint8_t *record = &ndef_data[2];
        if (record[0] == 0xd1) { // NDEF record header
            size_t type_len = record[1];
            size_t payload_len = record[2];
            uint8_t *payload = &record[3 + type_len];
            uint8_t language_code_len = payload[0] & 0x3F; // Length of the language code
            uint8_t *text = &payload[1 + language_code_len]; // Text starts after the language code
            size_t text_len = payload_len - 1 - language_code_len;
            printf("NDEF Text: %.*s\n", (int)text_len, text);
        }
    }

    nfc_close(pnd);
    nfc_exit(context);
    return 0;
}
