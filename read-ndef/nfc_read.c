#include <nfc/nfc.h>
#include <stdio.h>
#include <stdlib.h>

void message_decoder(const uint8_t *pbtData, const size_t szBytes);

int main(void) {
    nfc_device *pnd;
    nfc_context *context;
    nfc_target nt;
    uint8_t abtRx[16]; // Typical block size is 16 bytes
    int res;

    // Initialize libnfc and set the context
    nfc_init(&context);
    if (context == NULL) {
        printf("Unable to init libnfc (malloc)\n");
        exit(EXIT_FAILURE);
    }

    // Open the NFC device
    pnd = nfc_open(context, NULL);
    if (pnd == NULL) {
        printf("ERROR: %s\n", "Unable to open NFC device.");
        nfc_exit(context);
        exit(EXIT_FAILURE);
    }

    // Initiate the NFC device
    if (nfc_initiator_init(pnd) < 0) {
        nfc_perror(pnd, "nfc_initiator_init");
        nfc_close(pnd);
        nfc_exit(context);
        exit(EXIT_FAILURE);
    }

    printf("NFC reader: %s opened\n", nfc_device_get_name(pnd));

    // Poll for a target
    const nfc_modulation nm = {
        .nmt = NMT_ISO14443A,
        .nbr = NBR_106,
    };

    if ((res = nfc_initiator_select_passive_target(pnd, nm, NULL, 0, &nt)) > 0) {
        printf("The following (NFC) ISO14443A tag was found:\n");

        // Loop through all blocks (assuming 16 blocks for simplicity)
        for (int block = 0; block < 64; block += 4) { // Adjusting the step to read more data
            uint8_t command[] = { 0x30, (uint8_t)block }; // Command to read block
            if ((res = nfc_initiator_transceive_bytes(pnd, command, sizeof(command), abtRx, sizeof(abtRx), 0)) > 0) {
                printf("Block %02d: ", block);
                message_decoder(abtRx, res);
            } else {
                printf("Error reading block %02d.\n", block);
            }
        }
    } else {
        printf("No NFC tag found.\n");
    }

    // Close the NFC device
    nfc_close(pnd);
    nfc_exit(context);
    return 0;
}

void message_decoder(const uint8_t *pbtData, const size_t szBytes) {
    // Simple example of decoding an NDEF message
    // This function should be expanded based on the specific NDEF message format
    printf("Decoded NDEF message: ");
    for (size_t i = 0; i < szBytes; i++) {
        if (pbtData[i] >= 32 && pbtData[i] <= 126) {
            printf("%c", pbtData[i]);
        } else {
            printf(".");
        }
    }
    printf("\n");
}
