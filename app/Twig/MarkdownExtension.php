<?php

namespace Tom32i\Phpillip\Twig;

use Tom32i\Phpillip\Service\Parsedown;
use Twig_SimpleFilter as SimpleFilter;

/**
 * Markdown extension
 */
class MarkdownExtension extends \Twig_Extension
{
    /**
     * {@inheritdoc}
     */
    public function getFilters()
    {
        return [
            new SimpleFilter('markdown', [$this, 'markdownify']),
        ];
    }

    /**
     * Parse Mardown to return HTML
     *
     * @param string $data
     *
     * @return string
     */
    public function markdownify($data)
    {
        $parser = new Parsedown();

        return $parser->parse($data);
    }

    /**
     * {@inheritdoc}
     */
    public function getName()
    {
        return 'markdown_extension';
    }
}