import base64
import hashlib
from getpass import getpass

# Generate key from password
def generate_key(password):
    return hashlib.sha256(password.encode()).digest()

# XOR encryption (simple but effective when combined with hashing)
def encrypt(text, password):
    key = generate_key(password)
    text_bytes = text.encode()

    encrypted = bytearray()
    for i in range(len(text_bytes)):
        encrypted.append(text_bytes[i] ^ key[i % len(key)])

    return base64.urlsafe_b64encode(encrypted).decode()

def decrypt(ciphertext, password):
    key = generate_key(password)
    data = base64.urlsafe_b64decode(ciphertext.encode())

    decrypted = bytearray()
    for i in range(len(data)):
        decrypted.append(data[i] ^ key[i % len(key)])

    return decrypted.decode()

def main():
    print("=== Simple Encryption Tool ===")

    while True:
        print("\n1. Encrypt")
        print("2. Decrypt")
        print("3. Exit")

        choice = input("Choose: ")

        if choice == "1":
            text = input("Enter text: ")
            password = getpass("Enter key: ")

            result = encrypt(text, password)
            print("\nEncrypted:")
            print(result)

        elif choice == "2":
            text = input("Enter encrypted text: ")
            password = getpass("Enter key: ")

            try:
                result = decrypt(text, password)
                print("\nDecrypted:")
                print(result)
            except:
                print("❌ Wrong key or invalid data")

        elif choice == "3":
            break

        else:
            print("Invalid choice")

if __name__ == "__main__":
    main()