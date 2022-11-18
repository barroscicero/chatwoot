<template>
  <div class="row csat--metrics-container">
    <div v-if="metrics.totalResponseCount" class="medium-6 report-card">
      <h4 class="rating--title">{{ this.$t('CSAT_REPORTS.TABLE.HEADER.RATING')}} </h4>
      <h3 class="heading">
        <div class="emoji--distribution">
          <div
            v-for="(rating, key, index) in ratingPercentage"
            :key="rating + key + index"
            class="emoji--distribution-item"
          >
            <span class="emoji--distribution-key"><b>{{
              csatRatings[key - 1].value
            }}</b>:</span>
            <span>{{ formatToPercent(rating) }}</span>
          </div>
        </div>
      </h3>
      <div class="emoji--distribution-chart">
        <woot-horizontal-bar :collection="chartData" :height="24" />
      </div>
    </div>
    <div v-if="metrics.totalResponseCount" class="medium-6 report-card">
      <h4 class="rating--title">{{ this.$t('CSAT_REPORTS.TABLE.HEADER.RATING_TECHNOLOGY')}} </h4>
      <h3 class="heading">
        <div class="emoji--distribution">
          <div
            v-for="(rating_technology, key, index) in ratingTechPercentage"
            :key="rating_technology + key + index"
            class="emoji--distribution-item"
          >
            <span class="emoji--distribution-key"><b>{{
              csatRatings[key - 1].value
            }}</b>:</span>
            <span>{{ formatToPercent(rating_technology) }}</span>
          </div>
        </div>
      </h3>
      <div class="emoji--distribution-chart">
        <woot-horizontal-bar :collection="chartTechData" :height="24" />
      </div>
    </div>
    <csat-metric-card
      :label="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.TOOLTIP')"
      :value="responseCount"
    />
    <csat-metric-card
      :label="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.TOOLTIP')"
      :value="formatToPercent(satisfactionScore)"
    />
    <csat-metric-card
      :label="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.TOOLTIP')"
      :value="formatToPercent(responseRate)"
    />
  </div>
</template>
<script>
import { mapGetters } from 'vuex';
import CsatMetricCard from './CsatMetricCard';
import { CSAT_RATINGS } from 'shared/constants/messages';

export default {
  components: {
    CsatMetricCard,
  },
  data() {
    return {
      csatRatings: CSAT_RATINGS,
    };
  },
  computed: {
    ...mapGetters({
      metrics: 'csat/getMetrics',
      ratingPercentage: 'csat/getRatingPercentage',
      ratingTechPercentage: 'csat/getRatingTechPercentage',
      satisfactionScore: 'csat/getSatisfactionScore',
      responseRate: 'csat/getResponseRate',
    }),
    responseCount() {
      return this.metrics.totalResponseCount
        ? this.metrics.totalResponseCount.toLocaleString()
        : '--';
    },
    chartData() {
      return {
        labels: ['Rating'],
        datasets: CSAT_RATINGS.map((rating, index) => ({
          label: rating.value,
          data: [this.ratingPercentage[index + 1]],
          backgroundColor: rating.color,
        })),
      }
    },
    chartTechData() {
      return {
        labels: ['Rating'],
        datasets: CSAT_RATINGS.map((rating, index) => ({
          label: rating.value,
          data: [this.ratingTechPercentage[index + 1]],
          backgroundColor: rating.color,
        })),
      }
    },
  },
  methods: {
    formatToPercent(value) {
      return value ? `${value}%` : '--';
    },
  },
};
</script>
<style lang="scss" scoped>
.csat--metrics-container {
  background: var(--white);
  margin-bottom: var(--space-two);
  border-radius: var(--border-radius-normal);
  border: 1px solid var(--color-border);
  padding: var(--space-normal);
}

.emoji--distribution {
  display: flex;
  justify-content: flex-end;

  .emoji--distribution-item {
    padding-left: var(--space-normal);
  }
}

.emoji--distribution-chart {
  margin-top: var(--space-small);
}

.emoji--distribution-key {
  margin-right: var(--space-micro);
}

.rating--title {
    font-size: var(--font-size-bigger);
    font-weight: var(--font-weight-feather);
    margin-bottom: 0;
    margin-top: var(--space-smaller);
  }

</style>
