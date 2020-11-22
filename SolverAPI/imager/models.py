from django.db import models
class UploadImageTest(models.Model):
    image = models.ImageField(upload_to='', blank=True, null=True)
  
