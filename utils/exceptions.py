class OperationFailed(Exception):
    def __init__(self, message: str):
        self.message = f"Operation failed: {message}"
        super().__init__(self.message)
