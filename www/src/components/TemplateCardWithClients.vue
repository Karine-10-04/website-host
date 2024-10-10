<script setup>
    import { animate } from '@/utils/animations.js'
    import { computed, onMounted, ref } from 'vue';

    const { delta, index, params } = defineProps(['delta', 'index', 'params'])

    const backgroundStyle = animate(params.background.animation)
    const titleStyle = animate(params.title.animation)
    const subTitleStyle = animate(params.subTitle.animation)
    const contentStyle = animate(params.content.animation)
    const clients = (params.clients || []).map((client, c, _clients) => {
        const n = Math.ceil((c + 1) / _clients.length * 100);
        return {
            text: client,
            animation: animate(`fadein, up-25-easeInOutSine`)
        }
    })

    const tar = 2 // time at rest (s)
    const tim = .5 // time in motion (s) 
    const ptr = ref() // client pointer
    const tick = () => {
        const d =  (new Date())
        const s = d.getTime() / 1E3 //d.getSeconds() + (d.getMilliseconds() / 1E3)
        ptr.value = (s % (clients.length * (tar + tim)))
    } 
    
    const deltas = computed(() => {
        return clients.map((client, c) => {
            const l = c * (tar + tim)
            const r = l + tar
            return (ptr.value < l)
                ? Math.max(-1, ptr.value - l)
                : (ptr.value > r)
                    ? Math.min(1, ptr.value - r )
                    : 0   
        })
    })

    onMounted(() => {
        setInterval(tick, 25) // 40FPS
    })


</script>
<template>
    <div class="min-h-screen flex flex-col">
        <div class="absolute inset-0 bg-cover bg-center bg-no-repeat"
            :style="`background-image: url(${params.background.src}); ${backgroundStyle(delta)};`" />

        <div class="w-full min-h-screen max-w-6xl mx-auto px-4 md:px-6 py-24">
            <div class="flex flex-col h-full lg:flex-row space-y-4 space-y-reverse lg:space-y-0 lg:space-x-20">
                <div class="flex-1 flex lg:opacity-[var(--stick-visibility)] order-1 lg:order-none items-center">
                    <div class="space-y-3">
                     
                        <div :class="`inline-flex ${params.subTitle.class}`"
                            :style="subTitleStyle(delta)" v-html="params.subTitle.text" />
                        <h2 :class="params.title.class"
                            :style="titleStyle(delta)" v-html="params.title.text" />
                        <p :class="params.content.class"
                            :style="contentStyle(delta)" v-html="params.content.text" />
                    </div>
                </div>
                <div class="flex-1 flex lg:opacity-[var(--stick-visibility)] order-last md:mt-20 items-center place-content-center backdrop-blur-sm backdrop-brightness-75 p-3">
                    <div v-for="(client, c) in clients" 
                        class="absolute offset-0 font-neutra-condensed text-4xl text-white font-extrabold"
                        :style="client.animation(deltas[c])" 
                        >{{ client.text }}</div>
                </div>
            </div>
        </div>
    </div>    
</template>