<script setup>
import { animate } from '@/utils/animations.js'

const { delta, index } = defineProps(['delta', 'index'])

const animationStyle = animate('right-100, spinccw-270, fadein-100, zoomin-2') 

</script>
<template>
    <div>
		<div
            class="relative flex justify-center items-center h-screen"
            :style="animationStyle(delta)"
		>
            <img :src="`https://picsum.photos/200?${index}`" class="h-3/4">
        </div>
    </div>
</template>