def get_encrypted_connection():
    from oci.key_management import KmsCryptoClient
    crypto = KmsCryptoClient(config)
    return crypto.decrypt(encrypted_data)