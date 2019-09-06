
<pre>
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);


use Magento\Framework\App\Bootstrap;

//require __DIR__ . '/app/bootstrap.php';
require dirname(__FILE__) . '/../app/bootstrap.php';

$params = $_SERVER;

$bootstrap = Bootstrap::create(BP, $params);

$obj = $bootstrap->getObjectManager();

$state = $obj->get('Magento\Framework\App\State');
$state->setAreaCode('frontend');

$productId = 29983;
$product = $obj->get('Magento\Catalog\Model\ProductRepository')
    ->getById($productId);

$imageId = 'product_thumbnail_image';
$_imageHelper = $obj->get('Magento\Catalog\Helper\ImageFactory');
$image = $_imageHelper->create()->init($product, $imageId)
    ->constrainOnly(TRUE)
    ->keepAspectRatio(TRUE)
    ->keepTransparency(TRUE)
    ->keepFrame(FALSE);

echo $image->getUrl();


$images = $product->getMediaGalleryImages();

echo $product->getThumbnail();

?>



<img src="<?php echo $image->getUrl(); ?>" />

    <p><?php echo $product->getThumbnail(); ?></p>

<?php

foreach ($images as $img) {
    print_r($img->getData());
}

var_dump($product->getSmallImage());

$helperImport = $obj->get('\Magento\Catalog\Helper\Image');

$imageUrl = $helperImport->init($product, 'product_page_image_small')
    ->setImageFile($product->getThumbnail()) // image,small_image,thumbnail
    ->constrainOnly(TRUE)
    ->keepAspectRatio(TRUE)
    ->keepTransparency(TRUE)
    ->keepFrame(FALSE)
    ->resize(75)
    ->getUrl();
echo $imageUrl;



?>

</pre>

<img src="<?php echo $imageUrl; ?>" />