import base64
import hashlib
import customtkinter as ctk

# --- Core Cryptography Logic ---
def generate_key(password):
    return hashlib.sha256(password.encode()).digest()

def encrypt(text, password):
    if not text or not password:
        raise ValueError("Text and password cannot be empty.")
    key = generate_key(password)
    text_bytes = text.encode()

    encrypted = bytearray()
    for i in range(len(text_bytes)):
        encrypted.append(text_bytes[i] ^ key[i % len(key)])

    return base64.urlsafe_b64encode(encrypted).decode()

def decrypt(ciphertext, password):
    if not ciphertext or not password:
        raise ValueError("Ciphertext and password cannot be empty.")
    key = generate_key(password)
    data = base64.urlsafe_b64decode(ciphertext.encode())

    decrypted = bytearray()
    for i in range(len(data)):
        decrypted.append(data[i] ^ key[i % len(key)])

    return decrypted.decode()


# --- UI Implementation ---
class CryptoApp(ctk.CTk):
    def __init__(self):
        super().__init__()

        # Window Configuration
        self.title("Secure Cipher Tool")
        self.geometry("550 := 600")
        self.minsize(500, 550)
        
        # Set default theme styling
        ctk.set_appearance_mode("Dark")
        ctk.set_default_color_theme("blue")

        # Title Header
        self.title_label = ctk.CTkLabel(
            self, 
            text="🔐 Cryptography Suite", 
            font=ctk.CTkFont(size=24, weight="bold")
        )
        self.title_label.pack(pady=(20, 10))

        # Tabview Setup
        self.tabview = ctk.CTkTabview(self, width=500, height=480)
        self.tabview.pack(padx=20, pady=(0, 20), fill="both", expand=True)

        self.tabview.add("Encrypt")
        self.tabview.add("Decrypt")

        self.setup_encrypt_tab()
        self.setup_decrypt_tab()

    def setup_encrypt_tab(self):
        tab = self.tabview.tab("Encrypt")
        
        # Input Text
        lbl1 = ctk.CTkLabel(tab, text="Plaintext to Encrypt:", font=ctk.CTkFont(weight="bold"))
        lbl1.pack(anchor="w", padx=20, pady=(15, 5))
        
        self.enc_input = ctk.CTkTextbox(tab, height=100)
        self.enc_input.pack(fill="x", padx=20, pady=5)

        # Secret Key
        lbl2 = ctk.CTkLabel(tab, text="Secret Key / Password:", font=ctk.CTkFont(weight="bold"))
        lbl2.pack(anchor="w", padx=20, pady=(10, 5))
        
        self.enc_pass = ctk.CTkEntry(tab, show="*")
        self.enc_pass.pack(fill="x", padx=20, pady=5)

        # Action Button
        self.enc_btn = ctk.CTkButton(tab, text="Encrypt Text", command=self.handle_encrypt)
        self.enc_btn.pack(fill="x", padx=20, pady=20)

        # Output Text
        lbl3 = ctk.CTkLabel(tab, text="Encrypted Ciphertext (Base64):", font=ctk.CTkFont(weight="bold"))
        lbl3.pack(anchor="w", padx=20, pady=(5, 5))
        
        self.enc_output = ctk.CTkTextbox(tab, height=100)
        self.enc_output.pack(fill="x", padx=20, pady=5)

    def setup_decrypt_tab(self):
        tab = self.tabview.tab("Decrypt")
        
        # Input Ciphertext
        lbl1 = ctk.CTkLabel(tab, text="Ciphertext to Decrypt:", font=ctk.CTkFont(weight="bold"))
        lbl1.pack(anchor="w", padx=20, pady=(15, 5))
        
        self.dec_input = ctk.CTkTextbox(tab, height=100)
        self.dec_input.pack(fill="x", padx=20, pady=5)

        # Secret Key
        lbl2 = ctk.CTkLabel(tab, text="Secret Key / Password:", font=ctk.CTkFont(weight="bold"))
        lbl2.pack(anchor="w", padx=20, pady=(10, 5))
        
        self.dec_pass = ctk.CTkEntry(tab, show="*")
        self.dec_pass.pack(fill="x", padx=20, pady=5)

        # Action Button
        self.dec_btn = ctk.CTkButton(tab, text="Decrypt Text", fg_color="#2b719e", hover_color="#1b4d6b", command=self.handle_decrypt)
        self.dec_btn.pack(fill="x", padx=20, pady=20)

        # Output Plaintext
        lbl3 = ctk.CTkLabel(tab, text="Decrypted Plaintext:", font=ctk.CTkFont(weight="bold"))
        lbl3.pack(anchor="w", padx=20, pady=(5, 5))
        
        self.dec_output = ctk.CTkTextbox(tab, height=100)
        self.dec_output.pack(fill="x", padx=20, pady=5)

    # --- UI Logic Handlers ---
    def handle_encrypt(self):
        self.enc_output.delete("1.0", ctk.END)
        text = self.enc_input.get("1.0", "end-1c").strip()
        password = self.enc_pass.get().strip()

        if not text or not password:
            self.enc_output.insert("1.0", "⚠️ Please enter both text and a security key.")
            return

        try:
            result = encrypt(text, password)
            self.enc_output.insert("1.0", result)
        except Exception as e:
            self.enc_output.insert("1.0", f"❌ Error: {str(e)}")

    def handle_decrypt(self):
        self.dec_output.delete("1.0", ctk.END)
        ciphertext = self.dec_input.get("1.0", "end-1c").strip()
        password = self.dec_pass.get().strip()

        if not ciphertext or not password:
            self.dec_output.insert("1.0", "⚠️ Please enter both ciphertext and the key.")
            return

        try:
            result = decrypt(ciphertext, password)
            self.dec_output.insert("1.0", result)
        except Exception:
            self.dec_output.insert("1.0", "❌ Wrong key or corrupt payload data.")


if __name__ == "__main__":
    app = CryptoApp()
    app.mainloop()